'use strict';

const { Gateway, Wallets } = require('fabric-network');


const gateway_buyer = new Gateway();
const gateway_tsp = new Gateway();
const gateway_seller = new Gateway();
const channelName = 'mychannel';
const chaincodeName = 'basic';

exports.getNetworkGateway = async function(wallet, ccp_buyer, ccp_tsp, ccp_seller) {
    try {
        await gateway_buyer.connect(ccp_buyer, {
            wallet,
            identity: 'buyer_user',
            discovery: { enabled: true, asLocalhost: true }
        });
        await gateway_tsp.connect(ccp_tsp, {
            wallet,
            identity: 'tsp_user',
            discovery: { enabled: true, asLocalhost: true }
        });
        await gateway_seller.connect(ccp_seller, {
            wallet,
            identity: 'seller_user',
            discovery: { enabled: true, asLocalhost: true }
        });
        const network_buyer = await gateway_buyer.getNetwork(channelName);
		const contract_buyer = network_buyer.getContract(chaincodeName);
        const network_tsp = await gateway_tsp.getNetwork(channelName);
		const contract_tsp = network_tsp.getContract(chaincodeName);
        const network_seller = await gateway_seller.getNetwork(channelName);
		const contract_seller = network_seller.getContract(chaincodeName);

        console.log('Returning Contracts');
        return { contract_buyer, contract_tsp, contract_seller };

    } catch (error) {
        console.error(`${error}`);
    }
}

exports.disconnectGateway = async function() {
    try {
        gateway_buyer.disconnect();
        gateway_tsp.disconnect();
        gateway_seller.disconnect();
    } catch (error) {
        console.error(`${error}`);
    }
    
}