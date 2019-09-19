// This file can be replaced during build by using the `fileReplacements` array.
// `ng build --prod` replaces `environment.ts` with `environment.prod.ts`.
// The list of file replacements can be found in `angular.json`.

import { LobbyConnectionComponent } from '../app/lobby_connection_app/lobby_connection_app.component';
import { AdminComponent } from 'src/app/admin_app/admin_app.component';

export const environment = {
  production: false,
  firebaseConfig: {
    apiKey: 'AIzaSyCAYmbCaUC7kVFs1nf02_jDN2p8CvVnSkI',
    authDomain: 'agile-serious-game-241306.firebaseapp.com',
    databaseURL: 'https://agile-serious-game-241306.firebaseio.com',
    projectId: 'agile-serious-game-241306',
    storageBucket: 'agile-serious-game-241306.appspot.com',
    messagingSenderId: '158677336925',
    appId: '1:158677336925:web:f1b1ad346c8e4d1c'
  },
  appRoutes:
  [
    { path: '',
      redirectTo: '/lobby',
      pathMatch: 'full'
    },
    {
      path: 'lobby',
      component: LobbyConnectionComponent,
      data: {title: 'Connection à une partie'}
    },
    {
      path: 'lobby/:lobby_key',
      component: AdminComponent,
      data: {title: 'Administration'}
    }
  ]
};

/*
 * For easier debugging in development mode, you can import the following file
 * to ignore zone related error stack frames such as `zone.run`, `zoneDelegate.invokeTask`.
 *
 * This import should be commented out in production mode because it will have a negative impact
 * on performance if an error is thrown.
 */
// import 'zone.js/dist/zone-error';  // Included with Angular CLI.
