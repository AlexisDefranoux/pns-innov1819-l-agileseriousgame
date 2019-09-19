import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TimerComponent } from './timer_app.component';
import { NgCircleProgressModule } from 'ng-circle-progress';
import {MatCardModule} from '@angular/material/card';


@NgModule({
    declarations: [TimerComponent],
    imports: [ CommonModule, NgCircleProgressModule, MatCardModule ],
    exports: [TimerComponent],
    providers: [],
})
export class TimerModule {}
