export class UserStoryFactory {

    userStories =
    [
        {
            id: 0,
            score: 100
        },
        {
            id: 1,
            score: 200
        },
        {
            id: 2,
            score: 200
        },
        {
            id: 3,
            score: 400
        }
    ];


    findUserStoryById(id: number): any {
        return this.userStories[id];
    }



}
