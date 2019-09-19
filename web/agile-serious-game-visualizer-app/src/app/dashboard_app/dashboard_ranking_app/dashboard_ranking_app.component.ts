import { Component, OnInit, OnChanges } from '@angular/core';
import { FirestoreService } from 'src/services/firestore.service';
import { ActivatedRoute } from '@angular/router';
import { mergeMap } from 'rxjs/operators';


@Component({
    selector: 'app-dashboard-ranking',
    templateUrl: './dashboard_ranking_app.component.html',
    styleUrls: ['./dashboard_ranking_app.component.css']
})
export class RankingComponent implements OnInit, OnChanges {

    private title: string;
    private teamsRanking: any[] = [];
    private options;
    private columnNames: string[] = ['Nom d\'équipe', 'Score'];
    private type: any;

    constructor(private service: FirestoreService, private route: ActivatedRoute) {
        this.title = 'Classement des équipes';
        this.options = {
            hAxis: {
               title: 'Nom d\'équipe'
            },
            vAxis: {
               minValue: 0
            },

         };
         this.type = 'ColumnChart';
     }


     gather(): void {
        this.route.params.pipe(mergeMap((params) =>
            this.service.getTeamsRanking(params['lobby_key'])))
            .subscribe((teams) => {
                this.teamsRanking = teams;
            });
     }

    ngOnInit(): void {
        this.gather();
     }


     ngOnChanges(): void {
        this.gather();
     }





}
