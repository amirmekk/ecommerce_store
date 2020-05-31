'use strict';

/**
 * Read the documentation (https://strapi.io/documentation/3.0.0-beta.x/concepts/controllers.html#core-controllers)
 * to customize this controller
 */

module.exports = {
    update: async (ctx, next) => {
        const { products } = ctx.request.body;
        return strapi.services.cart.update(ctx.params, {
            products: JSON.parse(products),
        })
    }
};
