import { Component, OnInit, OnChanges } from '@angular/core';
import { FirestoreService } from 'src/services/firestore.service';
import { ActivatedRoute } from '@angular/router';
import { mergeMap } from 'rxjs/operators';

@Component({
    selector: 'app-dashboard-continuity',
    templateUrl: './dashboard_continuity_app.component.html',
    styleUrls: ['./dashboard_continuity_app.component.css']
})
export class ContinuityComponent implements OnInit, OnChanges {


    private title: string;
    private teamsRanking: any[] = [];
    private options;
    private columnNames: string[] = []; // get team names
    private type: any;

    constructor(private service: FirestoreService, private route: ActivatedRoute) {
        this.title = 'Score par itérations';
        this.options = {
            hAxis: {
               title: 'Itération'
            },
            vAxis: {
               title: 'Score'
            },
            pointSize: 5
         };
         this.type = 'LineChart';
     }


     gather(): void {
        this.route.params.pipe(mergeMap((params) => {
            this.service.getTeams(params['lobby_key']).subscribe((teams) => {
                this.columnNames.push('Equipe');
                teams.forEach(element => {
                    this.columnNames.push(element.id);
                });
            });
            return this.service.getTeamsContinuity(params['lobby_key']);
        })).subscribe((data) => {
            this.teamsRanking = data;
            console.log(this.teamsRanking);
        });
     }

    ngOnInit(): void {
        this.gather();
     }

    ngOnChanges(): void {
        this.gather();
    }

}
