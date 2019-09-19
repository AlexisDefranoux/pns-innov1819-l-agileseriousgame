import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PerformanceComponent } from './dashboard_performance_app.component';
import { FirestoreService } from 'src/services/firestore.service';
import { GoogleChartsModule } from 'angular-google-charts';
import {MatCardModule} from '@angular/material/card';
import {MatProgressSpinnerModule} from '@angular/material/progress-spinner';

@NgModule({
    declarations: [PerformanceComponent],
    imports: [ CommonModule, GoogleChartsModule, MatCardModule, MatProgressSpinnerModule ],
    exports: [PerformanceComponent],
    providers: [FirestoreService],
})
export class PerformanceModule {}
