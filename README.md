# Custody-Transfer-using-Hyperledger-Fabric
 
Go to the Test_Network directory: \

  ./network.sh down \
  
  ./network.sh up createChannel \
  
  docker run -i -t -d -p 9051 hyperledger/fabric-peer:latest \
  
  docker run -i -t -d -p 13051 hyperledger/fabric-peer:latest \
  
  ./network.sh deployCC -ccn basic -ccp ../Custody-Transfer-using-Hyperledger-Fabric/ct-chaincode-js/ -ccl javascript -cci InitLedger \
  ./network.sh deployCC -ccn basic -ccp chaincode/ -ccl javascript -cci InitLedger
