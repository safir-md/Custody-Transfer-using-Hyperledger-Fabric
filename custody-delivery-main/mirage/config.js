import { Response } from 'miragejs';

export default function() {
  this.passthrough('http://localhost:3000/**');
  this.post('/login', (schema, request) => {
    const attrs = JSON.parse(request.requestBody);
    if (attrs.username === 'throw') {
      return new Response(422, { some: 'header'}, { error: 'Invalid username or password' });
    }
    return new Response(200);
  });

  this.post('/place_order', () => {
    return new Response(200);
  });

  this.get('/display_asset', () => {
    return {
      assetId: 'Crude Oil',
      blockedQuantity: 10,
      buyerCountry: 'Germany',
      buyerVolume: 10,
      globalMSSBuyer: 'ISO 8222 Standard',
      globalMSSSeller: 'American Petroleum Institute (API) Standard',
      location: 'USA',
      nationalMSSBuyer: 'PTB Standard',
      nationalMSSSeller: 'American Petroleum Institute (API) Standard',
      rate: '2.57',
      sellerCountry: 'USA',
      sellerVolume: '1000'
    }
  });

  this.get('/get_history', () => {
    return [{
      Timestamp: {
        seconds: '1612410755',
        nanos: '161241075500'
      },
      Value: {
        assetId: 'Crude Oil',
        blockedQuantity: 10,
        buyerCountry: 'Germany',
        buyerVolume: 10,
        globalMSSBuyer: 'ISO 8222 Standard',
        globalMSSSeller: 'American Petroleum Institute (API) Standard',
        location: 'USA',
        nationalMSSBuyer: 'PTB Standard',
        nationalMSSSeller: 'American Petroleum Institute (API) Standard',
        rate: '2.57',
        sellerCountry: 'USA',
        sellerVolume: '1000'
      }
    }, {
      Timestamp: {
        seconds: '1612410755',
        nanos: '161241075500'
      },
      Value: {
        assetId: 'Crude Oil',
        blockedQuantity: 10,
        buyerCountry: 'Germany',
        buyerVolume: 10,
        globalMSSBuyer: 'ISO 8222 Standard',
        globalMSSSeller: 'American Petroleum Institute (API) Standard',
        location: 'USA',
        nationalMSSBuyer: 'PTB Standard',
        nationalMSSSeller: 'American Petroleum Institute (API) Standard',
        rate: '2.57',
        sellerCountry: 'USA',
        sellerVolume: '1000'
      }
    }, {
      Timestamp: {
        seconds: '1612410755',
        nanos: '161241075500'
      },
      Value: {
        assetId: 'Crude Oil',
        blockedQuantity: 10,
        buyerCountry: 'Germany',
        buyerVolume: 10,
        globalMSSBuyer: 'ISO 8222 Standard',
        globalMSSSeller: 'American Petroleum Institute (API) Standard',
        location: 'USA',
        nationalMSSBuyer: 'PTB Standard',
        nationalMSSSeller: 'American Petroleum Institute (API) Standard',
        rate: '2.57',
        sellerCountry: 'USA',
        sellerVolume: '1000'
      }
    }]
  });

  this.post('/reload_qty', () => {
    return new Response(200);
  });

  this.get('/blocked_qty', () => {
    return {
      qty: 100
    }
  })
  this.post('/update_location', () => {
    return new Response(200);
  });
}
