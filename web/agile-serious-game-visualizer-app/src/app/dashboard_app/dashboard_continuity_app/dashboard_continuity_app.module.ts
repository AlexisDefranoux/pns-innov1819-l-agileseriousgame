import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ContinuityComponent } from './dashboard_continuity_app.component';
import { GoogleChartsModule } from 'angular-google-charts';
import { MatCardModule } from '@angular/material/card';


@NgModule({
    declarations: [ContinuityComponent],
    imports: [ CommonModule, GoogleChartsModule, MatCardModule ],
    exports: [ContinuityComponent],
    providers: [],
})
export class ContinuityModule {}
