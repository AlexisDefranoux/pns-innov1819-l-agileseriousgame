import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DashboardComponent } from './dashboard_app.component';
import { FirestoreService } from 'src/services/firestore.service';
import { RankingModule } from './dashboard_ranking_app/dashboard_ranking_app.module';
import {MatCardModule} from '@angular/material/card';
import { PerformanceModule } from './dashboard_performance_app/dashboard_performance_app.module';
import { ContinuityModule } from './dashboard_continuity_app/dashboard_continuity_app.module';


@NgModule({
    declarations: [DashboardComponent],
    imports: [ CommonModule, RankingModule, MatCardModule, PerformanceModule, ContinuityModule ],
    exports: [DashboardComponent],
    providers: [FirestoreService],
})
export class DashboardModule {}
