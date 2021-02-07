'use strict';

const { buildCCPOrg1, buildCCPOrg5, buildCCPOrg6 } = require('./AppUtil.js');

exports.getNetworkCCP = async function() {
    try {
        const ccp_buyer = buildCCPOrg1();
        const ccp_tsp = buildCCPOrg5();
        const ccp_seller = buildCCPOrg6();

        return { ccp_buyer, ccp_tsp, ccp_seller };

    } catch (error) {
        const ccp = buildCCPOrg1();
    }
}
