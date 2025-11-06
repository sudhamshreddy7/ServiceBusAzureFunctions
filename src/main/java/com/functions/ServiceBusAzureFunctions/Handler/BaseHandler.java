package com.functions.ServiceBusAzureFunctions.Handler;

public interface BaseHandler {
    public abstract String handle(String message);
}
