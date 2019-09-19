import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RankingComponent } from './dashboard_ranking_app.component';
import { GoogleChartsModule } from 'angular-google-charts';
import {MatCardModule} from '@angular/material/card';
import {MatProgressSpinnerModule} from '@angular/material/progress-spinner';

@NgModule({
    declarations: [RankingComponent],
    imports: [ CommonModule, GoogleChartsModule, MatCardModule, MatProgressSpinnerModule ],
    exports: [RankingComponent],
    providers: [],
})
export class RankingModule {}
