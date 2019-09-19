import { BrowserModule, Title } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import {BrowserAnimationsModule} from '@angular/platform-browser/animations';
import { AppComponent } from './app.component';
import { LobbyConnectionModule } from './lobby_connection_app/lobby_connection_app.module';
import { RouterModule } from '@angular/router';
import { AngularFireModule } from '@angular/fire';
import { AngularFirestoreModule } from '@angular/fire/firestore';
import { environment } from '../environments/environment';
import { RankingModule } from './dashboard_app/dashboard_ranking_app/dashboard_ranking_app.module';
import { GoogleChartsModule } from 'angular-google-charts';
import { AdminModule } from './admin_app/admin_app.module';
import { NgCircleProgressModule } from 'ng-circle-progress';




@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    LobbyConnectionModule,
    AdminModule,
    AngularFireModule.initializeApp(environment.firebaseConfig),
    AngularFirestoreModule,
    RankingModule,
    GoogleChartsModule,
    NgCircleProgressModule.forRoot(),
    RouterModule.forRoot(environment.appRoutes)
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
