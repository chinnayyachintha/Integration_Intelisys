// index.js

const payments = {}; // In-memory store for demonstration

// Create Payment Function
exports.createPayment = async (event) => {
    const { amount, currency, description } = JSON.parse(event.body);
    const paymentId = Date.now().toString(); // Unique ID for the payment

    // Store the payment
    payments[paymentId] = { amount, currency, description, status: 'Pending' };

    return {
        statusCode: 201,
        body: JSON.stringify({
            message: 'Payment created successfully',
            paymentId: paymentId,
            paymentDetails: payments[paymentId],
        }),
    };
};

// Get Payment Function
exports.getPayment = async (event) => {
    const paymentId = event.pathParameters.paymentId;

    // Check if the payment exists
    if (!payments[paymentId]) {
        return {
            statusCode: 404,
            body: JSON.stringify({
                message: 'Payment not found',
            }),
        };
    }

    return {
        statusCode: 200,
        body: JSON.stringify({
            paymentId: paymentId,
            paymentDetails: payments[paymentId],
        }),
    };
};

// Delete Payment Function
exports.deletePayment = async (event) => {
    const paymentId = event.pathParameters.paymentId;

    // Check if the payment exists
    if (!payments[paymentId]) {
        return {
            statusCode: 404,
            body: JSON.stringify({
                message: 'Payment not found',
            }),
        };
    }

    // Delete the payment
    delete payments[paymentId];

    return {
        statusCode: 200,
        body: JSON.stringify({
            message: 'Payment deleted successfully',
        }),
    };
};
