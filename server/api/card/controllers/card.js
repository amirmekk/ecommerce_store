'use strict';

/**
 * A set of functions called "actions" for `card`
 */

const axios = require('axios');
require('dotenv').config();
const secretKey = process.env.SECRETKEY;
const stripe = require('stripe')(`${secretKey}`);

module.exports = {
  index: async (ctx, next) => {
    const stripeId = ctx.request.querystring;
    const stripeCustomerData = await stripe.customers.retrieve(stripeId);
    const cardData = stripeCustomerData.sources.data;
    ctx.send(cardData);
  },
  add: async (ctx, next) => {
    const { customer, source } = ctx.request.body;
    //const card = await stripe.customers.createSource(customer, { source });
    const card = await stripe.paymentMethods.attach(
      source,
      { customer: customer },

    );
    ctx.send(card);
  }
};
