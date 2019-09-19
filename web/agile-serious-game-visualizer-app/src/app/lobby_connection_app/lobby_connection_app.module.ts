import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {MatInputModule} from '@angular/material/input';
import {LobbyConnectionComponent} from './lobby_connection_app.component';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import {MatButtonModule} from '@angular/material/button';
import { FirestoreService } from 'src/services/firestore.service';
import {MatCardModule} from '@angular/material/card';
import { RouterModule } from '@angular/router';

@NgModule({
    declarations: [LobbyConnectionComponent],
    imports: [
        CommonModule,
        MatInputModule,
        FormsModule,
        ReactiveFormsModule,
        MatButtonModule,
        MatCardModule,
        RouterModule
     ],
    exports: [LobbyConnectionComponent],
    providers: [FirestoreService],
})
export class LobbyConnectionModule {}
