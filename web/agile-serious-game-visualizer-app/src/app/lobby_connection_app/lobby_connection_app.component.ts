import { Component, OnInit, OnDestroy } from '@angular/core';
import {FormControl, Validators} from '@angular/forms';
import { FirestoreService } from 'src/services/firestore.service';
import { Router } from '@angular/router';
import { Subscription } from 'rxjs';

@Component({
    selector: 'app-lobby-connection',
    templateUrl: './lobby_connection_app.component.html',
    styleUrls: ['./lobby_connection_app.component.css']
})
export class LobbyConnectionComponent implements OnInit, OnDestroy {

    lobbyKeyFormControl = new FormControl('', [
        Validators.required,
        Validators.minLength(6),
        Validators.maxLength(6)
      ]);

    loading = false;
    subscription: Subscription;



    constructor(private service: FirestoreService, private router: Router) {
    }


    async onConnect() {
        this.loading = true;
        this.subscription = await this.service.getLobby(this.lobbyKeyFormControl.value).subscribe((data) => {
            console.log(data);
            const id = data.id;
            this.router.navigate(['lobby', id]);
        });
        this.loading = false;
    }

    ngOnInit(): void { }


    ngOnDestroy(): void {
        this.subscription.unsubscribe();
    }

}
