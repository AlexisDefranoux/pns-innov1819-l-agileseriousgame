# PNS Innov

Polytech Nice Sophia

## Agile Serious Game

**Team L :**
- Camille Julien
- Simon Serrano
- Jiaqi Lui
- Alexis Defranoux

## Introduction

The objective of the application is to facilitate and dynamize the organization of the agile game "Birdie-Birdie".

## State of the art

State of the art of the solution and innovations:
- [Sprint #1](https://github.com/PNS-PS7-1819/pns-innov1819-l-agileseriousgame/blob/master/SOTA/phase1-L-AgileSeriousGame.pdf)
- [Sprint #2](https://github.com/PNS-PS7-1819/pns-innov1819-l-agileseriousgame/blob/master/SOTA/phase2-L-AgileSeriousGame.pdf)

## Lean Canvas

- The lean canvas can be found following this link: [Lean Canvas](https://github.com/PNS-PS7-1819/pns-innov1819-l-agileseriousgame/blob/master/SOTA/LeanCanvas-L-AgileSeriousGame.pdf)

## Getting Started

### Flutter

This project is a starting point for a Flutter application.
- Framework version :`1.5.4`
- Dart version : `>=2.2.0 <3.0.0`

For help getting started with Flutter : [online documentation](https://flutter.dev/docs)

### Web visualisation

This project rests on an Angular application for the web visualisation. Angular version is `6.9.0`.
To run the project for the first time use `npm install` and then `npm start` to launch the web app.
Then open any browser and go to [localhost:4200](http://localhost:4200/lobby).

To connect to a lobby, use the application to generate a firebase lobby key and paste it on the field
of the Angular app. Once connected you will be able to see the same graphs as on the app while being a facilitator.

### Firebase

This project depends on Firebase as a backend.
- Firebase core: `^0.4.0`
- Cloud Firestore: `^0.12.0`

For help getting started with FireBase : [Get started with FireBase and Flutter](https://firebase.google.com/docs/flutter/setup)

## Architecture

Nous avons actuellement deux projets : un projet Angular et un projet Flutter.
Nous avons donc fait une application répartie sur deux interface.
Ils utilisent tous les deux Firebase en rest :
![](https://i.imgur.com/DGx0ROp.png)

Notre architecture Flutter est organisé comme ceci : 
- Une classe par page
- Plusieurs widegts dans une page

## License

Copyright 2019 © Team-L-Agile-Serious-Game