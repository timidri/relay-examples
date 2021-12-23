# Local development with Relay

This readme describes the process how to setup local development. You can use this workflow:

- for step development
- for content development intended to be run by an existing Relay step.

The below step by step guide assumes you want do develop a Powershell script which will run using the `relaysh/powershell-step-run` step.

## Preparation

1. Install the Relay CLI for your OS from the [Github release page](https://github.com/puppetlabs/relay/releases).
1. Create a [metadata](test-metadata.yaml) file for the the step you want to run locally. Use the [test-metadata.yaml](test-metadata.yaml) as an example. Refer to documentation [here](https://relay.sh/docs/developers/step-authoring/).
The metadata file specifics the context for the step to run which would normally be provided by a Relay workflow.

The example metadata file conains the following sections:

1. `connections` - here, you can specify your own connections for testing. *NOTE* - don't push this metadata file to Github if you are using real connection secrets! In this example, an ssh connection is created to be able to fetch a poweshell script from a git repository.
1. `secrets` - you can specify your secrets here which you normally would add to a workflow. 
1. `runs` - this section mimics a workflow run and lists out steps which are part of the run, along with their `spec` objects.

## Running the step using the metadata

1. Spin up a local metadata service by for step `inline` running

   ```bash
   relay dev metadata --input test-metadata.yaml --run 1 --step inline --debug
   ```

   This will result in output similar to:

   ```bash
   No command was supplied, awaiting requests. Set environment with:
   export METADATA_API_URL='http://:eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOlsiazhzLnJlbGF5LnNoL21ldGFkYXRhLWFwaS92MSJdLCJyZWxheS5zaC9uYW1lIjoiaW5saW5lIiwicmVsYXkuc2gvcnVuLWlkIjoiMSIsInN1YiI6InN0ZXBzLzY4Y2FhNGVkZjc4OGRkMTBmZWI4ZmRjNWYzZTc2YmIzZTFkNDhhNzkifQ.VgrWnb6O5ryDcNjBzvdGX5Jg1fmPL8jQonG4q_qbjYg@[::]:63527'
   ```

   The `relay dev metadata` command reads the supplied metadata file and starts a local instance of the Relay metadata service which the step container will access for fetching metadata about its context. This metadata service is normally part of the Relay SaaS infrastructure and is automatically available to the workflows running in Relay.

1. In a different terminal, export the variable as suggested. *NOTE* this assumes that your local docker setup allows containers to access the network of the host running docker. For Mac, replace `[::]` by `docker.host.internal` to allow for this connectivity.
1. In that same terminal, run the step container providing the `METADATA_API_URL` environment variable:

    ```bash
    docker run -it  -e "METADATA_API_URL=${METADATA_API_URL}" relaysh/powershell-step-run
    ```

    The step will run using its specified spec object as outlined in the metadata file. Docker will fetch the image from dockerhub if it is not yet locally present.
1. If you change the metadata file, you need to stop and re-run the `relay dev metadata` command, re-export the resulting `METADATA_API_URL` parameter and re-run the container.
1. You can run any step specified in the metadata file by supplying the step name to the `rely dev metadata` command in the `--step` parameter.
