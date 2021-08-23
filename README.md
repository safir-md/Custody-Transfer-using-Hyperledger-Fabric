# Custody-Transfer-using-Hyperledger-Fabric

## Project Details:
This project was carried out under a module, HIS Project (10 CP), in the Master's Course, High Integrity Systems at Frankfurt University of Applied Sciences. Please find the project report [here.](Docs/Team_Platinum_Final_Report.pdf)

## Project Team Members: 
Saﬁr Mohammad Shaikh, Parag Tambalkar, Vidya Gopalakrishnarao, Pranay Raman

## Technologies Used:
* Language: Shell, JavaScript
* FrontEnd: Ember JS
* BackEnd: Node JS
* Blockchain Network: Hyperledger Fabric 2.x
* Documentation: Latex

## How to Run?
1. Clone the Repository:
```sh
git clone https://github.com/Safir-Mohammad-Mustak-Shaikh/Custody-Transfer-using-Hyperledger-Fabric.git
```
2. Go to Test_Network directory and Bring the Network up:
```sh
cd Custody-Transfer-using-Hyperledger-Fabric/test-network
./network.sh down
./network.sh up createChannel
```
3. Install Chaincode
```sh
./network.sh deployCC -ccn basic -ccp ../asset-transfer-basic/chaincode-javascript/ -ccl javascript -cci InitLedger
```
4. Start Backend Server
```sh
npm install
node enrollAdmin.js
node registerUser.js
nodemon apiserver.js
```
5. Open new Terminal window
```sh
cd Custody-Transfer-using-Hyperledger-Fabric/custody-delivery-main
npm install
ember serve
```
6. Now, the app is running on port 4200.
