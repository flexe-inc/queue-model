# queue-model
Tools for modeling latencies in delayed job queues.

It's possible someone who understands queue theory better than  I can replace all of this code with a single math function implementation.

NB: This is a public repository; don't commit properietary information to it.

The general idea is:

You have a queue work items go into.  It's modeled as follows:

1. There's a minimum time increment you care about, i.e. 1 minute.
1. A dataset provides the ingress function, as a CSV of amount in per time increment. This means you can base it on a query of historical volume.
1. There's an approximately linear rate of maximum egress per time increment.
1. Amounts in queue are tracked based on how many time increments they have been in queue.
1. Using the ingress dataset, we walk through each time increment: ingress, egress, then increment time-in-queue for everything still there.
1. As we egress, we track what the maximum time-in-queue of any egressed item was

After we get through the full input data set we report the maximum time any item spent in the queue.


# Running it
Example code for running simulations can be run from here:

`ruby run_simulations.rb`

 - Todo - accept some command line params for run simulations; for now you can modify the code with the parameters of interest
 - Todo - make it possible for the step function to model exponential and/or linear backoff
 - Todo - provide more sophisticated statistics than max-time-in-queue
