package com.functions.ServiceBusAzureFunctions;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import com.microsoft.azure.functions.*;
import com.microsoft.azure.functions.annotation.*;

@SpringBootApplication
public class ServiceBusAzureFunctionsApplication {

	@FunctionName("sbprocessor")
 	public void serviceBusProcess(
    	@ServiceBusQueueTrigger(name = "msg",
                             queueName = "TestQueue",
                             connection = "myconnvarname") String message,
   		final ExecutionContext context
 	) {
    
			
 	}
}
