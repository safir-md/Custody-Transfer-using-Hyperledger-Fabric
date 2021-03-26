# Custody-Transfer-using-Hyperledger-Fabric
 
Go to the Test_Network directory: \

  ./network.sh down \
  
  ./network.sh up createChannel \
  
  ./network.sh deployCC\
  
Go to Application (server) directory: \

  npm install \
  
  node index.js
#############################################################################
                                      Procedure
#############################################################################


cd fabric-samples/test-network/

./network.sh down

./network.sh up createChannel

./network.sh deployCC -ccn basic -ccp ../ct-chaincode-js/ -ccl javascript -cci InitLedger

code .

change ip address in request.js and config.js file 


##################################VS Code Terminal 1#################################


cd client-application/Server/

npm install

node enrollAdmin.js

node registerUser.js

nodemon apiserver.js


##################################VS Code Terminal 2#################################


ip addr

cd custody delivery/

ember serve

ipaddress:4200/login

