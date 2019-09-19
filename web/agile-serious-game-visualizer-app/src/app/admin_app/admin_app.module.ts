import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AdminComponent } from './admin_app.component';
import { DashboardModule } from '../dashboard_app/dashboard_app.module';
import {MatTabsModule} from '@angular/material/tabs';
import { TimerModule } from '../timer_app/timer_app.module';

@NgModule({
    declarations: [AdminComponent],
    imports: [ CommonModule, DashboardModule, MatTabsModule, TimerModule ],
    exports: [AdminComponent],
    providers: [],
})
export class AdminModule {}
