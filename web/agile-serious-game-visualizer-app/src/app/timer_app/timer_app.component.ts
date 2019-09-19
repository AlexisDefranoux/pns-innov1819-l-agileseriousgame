import { Component, OnInit } from '@angular/core';
import { timer, Subscription } from 'rxjs';
import { ActivatedRoute } from '@angular/router';
import { FirestoreService } from 'src/services/firestore.service';
import { mergeMap } from 'rxjs/operators';


@Component({
    selector: 'app-timer',
    templateUrl: './timer_app.component.html',
    styleUrls: ['./timer_app.component.css']
})
export class TimerComponent implements OnInit {

    timer_val = 0;
    timer_max = [30, 10, 30, 10];
    phase = ['Planification', 'Réalisation', 'Revue', 'Retrospective'];
    timer_sub: Subscription;
    paused = false;
    iteration = 1;
    phase_iterator = 0;


    constructor(private service: FirestoreService, private route: ActivatedRoute) { }


    convertToTimerString(): string {
        let timerStr = '';
        if (this.timer_val === -1) {
            return '00:00';
        }
        if (this.timer_val > 60) {
            const minutes = this.timer_val / 60;
            if (minutes > 9) {
                timerStr += minutes + ':';
                if (this.timer_val % 60 < 10) {
                    timerStr += '0';
                }
                return timerStr + (this.timer_val % 60);
            } else {
                timerStr += '0' + minutes + ':';
                if (this.timer_val % 60 < 10) {
                    timerStr += '0';
                }
                return timerStr + (this.timer_val % 60);
            }
        } else {
            timerStr += '00:';
            if (this.timer_val % 60 < 10) {
                timerStr += '0';
            }
            return timerStr + this.timer_val;
        }
    }

    startTimer() {
        const source = timer(1000, 1000);
        this.timer_val = this.timer_max[this.phase_iterator];
        this.timer_sub = source.subscribe((val) => {
            if (!this.paused) {
                this.timer_val--;
            }
            if (this.timer_val === -1) {
                this.phase_iterator++;
                if (this.phase_iterator === 4) {
                    this.iteration++;
                    this.phase_iterator = 0;
                    this.timer_sub.unsubscribe();
                    return;
                }
                this.paused = true;
                this.timer_val = this.timer_max[this.phase_iterator];

            }

        });
    }

    ngOnInit(): void {
        this.route.params.pipe(mergeMap(params => {
            return this.service.getTimer(params['lobby_key']);
        })).subscribe((bool) => {
            if (bool) {
                if (this.timer_sub !== undefined) {
                    this.paused = false;
                } else if (this.phase_iterator === 0) {
                    this.startTimer();
                }
            } else {
                if (this.timer_sub !== undefined) {
                    this.paused = true;
                }
            }
        });
     }
}
