import { Component, OnInit, OnChanges } from '@angular/core';
import { FirestoreService } from 'src/services/firestore.service';
import { ActivatedRoute } from '@angular/router';
import { mergeMap } from 'rxjs/operators';

@Component({
    selector: 'app-dashboard-performance',
    templateUrl: './dashboard_performance_app.component.html',
    styleUrls: ['./dashboard_performance_app.component.css']
})
export class PerformanceComponent implements OnInit, OnChanges {

    private title: string;
    private teamsPerformance: any[] = [];
    private options;
    private columnNames: string[] = ['Nom d\'équipe', 'Accepté', 'Refusé'];
    private type: any;

    constructor(private service: FirestoreService, private route: ActivatedRoute) {
        this.title = 'Performance des équipes';
        this.options = {
            hAxis: {
               title: 'Nom d\'équipe'
            },
            vAxis: {
               minValue: 0
            },

         };
         this.type = 'BarChart';
     }

     gather(): void {
        this.route.params.pipe(mergeMap((params) => {
            return this.service.getTeamsPerformance(params['lobby_key']);
        })).subscribe((perf) => {
            this.teamsPerformance = perf;
        });
     }

    ngOnInit(): void {
        this.gather();
     }


     ngOnChanges(): void {
        this.gather();
     }
}
