'use strict';

/**
 * Read the documentation (https://strapi.io/documentation/3.0.0-beta.x/concepts/controllers.html#core-controllers)
 * to customize this controller
 */

const axios = require('axios');
require('dotenv').config();
const secretKey = process.env.SECRETKEY;
const stripe = require('stripe')(`${secretKey}`);
const { v4: uuidv4 } = require('uuid');

module.exports = {
    create: async (ctx) => {
        const { amount, products, source, customer } = ctx.request.body;
        const charge = {
            amount: Number(amount) * 100,
            currency: 'usd',
            customer,
            source,
            payment_method_types: ['card'],
        };
        const idempotencyKey = uuidv4();
        await stripe.paymentIntents.create(charge, {
            idempotencyKey: idempotencyKey
        });
        return strapi.services.order.add({
            amount,
            products: JSON.parse(products),
            user: ctx.state.user
        });
    }
};
