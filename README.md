# Custody-Transfer-using-Hyperledger-Fabric
 
Go to the Test_Network directory: \

  ./network.sh down \
  
  ./network.sh up createChannel \
  
  ./network.sh deployCC\
  
Go to Application (server) directory: \

  npm install \
  
  node index.js
#############################################################################
#############################################################################

cd fabric-samples/test-network/

./network.sh down

./network.sh up createChannel

./network.sh deployCC -ccn basic -ccp ../ct-chaincode-js/ -ccl javascript -cci InitLedger

code .

cd client-application/Server/

npm install

node enrollAdmin.js

node registerUser.js

nodemon apiserver.js


##################################WSL#################################
######################################################################

ip addr

ember serve

######################Browser##########################
ipaddress:3000/display_asset
