import { Injectable } from '@angular/core';
import { Observable, observable} from 'rxjs';
import { AngularFirestore } from '@angular/fire/firestore';
import { UserStoryFactory} from 'src/model/user_story.model';
import { mergeMap, map } from 'rxjs/operators';

@Injectable({
    providedIn: 'root',
  })
export class FirestoreService {





    constructor(private firestore: AngularFirestore) {
    }


    getLobby(lobby_key: string): Observable<any> {
        return this.firestore.collection('lobby').doc(lobby_key)
        .snapshotChanges().pipe(map((lobby) => {
            console.log(lobby);
            return {id: lobby.payload.id, ...lobby.payload.data()};
        }));
    }


    getTeamsAndStoryHistory(lobby_key?: string): Observable<any[]> {

        return this.firestore.collection('lobby').doc(lobby_key)
            .collection('team').snapshotChanges().pipe(mergeMap((teamsDoc) => {
                const teams = [];
                    teamsDoc.forEach((doc) => {
                        let userStories = [];
                        let team_id;
                        this.getUserStoriesOfTeam(lobby_key, doc.payload.doc.id).subscribe((story) => {
                            userStories = story;
                            team_id = doc.payload.doc.id;
                            teams.push({
                                id: team_id,
                                stories : userStories
                            });
                        });
                    });
                    console.log(teams);
                    return new Observable<any[]>((observer) => observer.next(teams));
            }));
    }


    getTeamsRanking(lobby_key?: string): Observable<any[]> {
        return this.firestore.collection('lobby').doc(lobby_key)
            .collection('team').snapshotChanges().pipe(mergeMap((teamsDoc) => {
                let teams = [];
                    teamsDoc.forEach((doc) => {
                        let team_id;
                        let score = 0;
                        this.getUserStoriesOfTeam(lobby_key, doc.payload.doc.id).subscribe((stories) => {

                                team_id = doc.payload.doc.id;
                                stories.forEach(story => {
                                    if (story.state === 'validated') {
                                        score += story.score;
                                    }
                                    if (story.state === 'refused') {
                                        score -= story.score;
                                    }
                                });
                                const val = [];
                                val.push(team_id);
                                val.push(score);
                                teams.push(val);

                        });
                    });
                    teams = teams.sort((a, b) => b[1] - a[1]);
                    return new Observable<any[]>((observer) => observer.next(teams));
            }));
    }


    getTeamsPerformance(lobby_key?: string): Observable<any[]> {
        return this.getTeams(lobby_key).pipe(mergeMap(teams => {
            const iteration = [];
            for (let i = 1; i < 4; i++) {
                const teamsTab = [];
                teams.forEach(team => {
                    let team_id;
                    let accepted = 0;
                    let refused = 0;
                    this.getUserStoriesOfTeam(lobby_key, team.id).subscribe((stories) => {
                        team_id = team.id;

                            stories.forEach(story => {
                                if (story.iteration === i) {
                                    if (story.state === 'validated') {
                                        accepted += story.score;
                                    }
                                    if (story.state === 'refused') {
                                        refused += story.score;
                                    }
                                }
                            });
                            const val = [];
                            val.push(team_id);
                            val.push(accepted);
                            val.push(refused);
                            teamsTab.push(val);

                    });
                });
                iteration.push(teamsTab);
            }
            return new Observable<any[]>(observer => observer.next(iteration));
        }));
    }

    getTeams(lobby_key?: string): Observable<any> {
        return this.firestore.collection('lobby').doc(lobby_key).collection('team').snapshotChanges().pipe(
            map((teamsDoc) => {
                const teams = [];
                teamsDoc.forEach((doc) => {
                    teams.push({
                        id: doc.payload.doc.id
                    });
                });
                return teams;
        }));
    }


    getUserStoriesOfTeam(lobby_key?: string, team_id?: string): Observable<any> {
        return this.firestore.collection('lobby').doc(lobby_key)
            .collection('team').doc(team_id).collection('history').snapshotChanges().pipe(map((data) => {
                const userStory = [];
                const userStoryFactory = new UserStoryFactory();
                data.forEach((doc) => {
                    const story = userStoryFactory.findUserStoryById(doc.payload.doc.data()['id']);
                    userStory.push({
                        ...story,
                        state: doc.payload.doc.data()['state'],
                        iteration: doc.payload.doc.data()['iteration']
                    });
                });
                return userStory;
            }));

    }


    getTeamsContinuity(lobby_key?: string): Observable<any[]> {
        return this.getTeams(lobby_key).pipe(mergeMap(teams => {
            const res = [];
            for (let i = 1; i < 4; i++) {
                const it = [];
                it.push(i);
                teams.forEach(team => {
                    this.getUserStoriesOfTeam(lobby_key, team.id).pipe(map((stories_data) => {
                        const stories = [];
                        stories_data.forEach(story => {
                            if (story.iteration === i) {
                                stories.push(story);
                            }
                        });
                        return stories;
                    })).subscribe(stories => {

                            let score = 0;
                            stories.forEach((story) => {
                                if (story.state === 'validated') {
                                    score += story.score;
                                }
                                if (story.state === 'refused') {
                                    score -= story.score;
                                }
                            });
                            it.push(score);

                    });
                });
                res.push(it);
            }
            return new Observable<any[]>(observer => observer.next(res));

        }));
    }


    getTimer(lobby_key?: string): Observable<boolean> {
        return this.firestore.collection('lobby').doc(lobby_key).snapshotChanges().pipe(map(data => {
            if (data.payload.data()) {
                return data.payload.data()['timer'];
            }
            return false;
        }));
    }






}
