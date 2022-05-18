# Sources

In SmartEvents, a `Source` is a component of a `Processor` that connects to an external source of events (hence the name)
and, if they are matched by a [Filter](FILTERS.md), automatically injects them in the system.

Processors containing sources are called **"source processors"**.

It is **not possible** to create a processor containing an [Action](ACTIONS.md) and a `Source` at the same time.

When a new source `Processor` is requested using the endpoint `/api/v1/bridges/{id}/processors` you must specify the `Source` to connect to and, optionally, one or more [Filters](FILTERS.md).
If no filter is specified, all the events coming from the `Source` are injected in the system.

[Transformations](TRANSFORMATIONS.md) are currently not supported in source processors.

## Parameters of a Source

Each `Source` has 2 parameters to specify:
- `type`: the type of the `Source`. This must be one of the supported `Source` types listed below
  - Attempting to use an unknown `Source` type will result in an Error from the Bridge API.
- `parameters`: A key/value map of configuration parameters for the `Source`
  - Only string for the `key` and `value` of the parameters are supported.
  - The required parameters are `Source` specific and documented in the list of supported `Sources`

## Supported Source Types

The following `Sources` are currently supported by Event Bridge:

### SlackSource

Read messages from a Slack channel (requires a working [bot token](https://api.slack.com/authentication/token-types#bot)).

#### SlackSource Configuration Parameters

* `channel` - The Slack channel name to read messages from.
* `token` - The Slack [bot token](https://api.slack.com/authentication/token-types#bot) needed to connect to the instance and access the channel.

#### Example of creating SlackSource
Can be found at [SourceProcessorDemo](dev/SourceProcessorDemo.md).

#### Example of generated event

This is an example of a CloudEvent generated by a _SlackSource_ every time it reads a new Slack message from the configured channel:

```json
{
  "specversion": "1.0",
  "id": "3ffb0383-e478-4667-89a3-362c35304749",
  "source": "RHOSE",
  "type": "SlackSource",
  "data": {
    "type": "message",
    "team": "T030FKT2TM0",
    "user": "U0307XF2KJH",
    "text": "Hello, World!",
    "blocks": [
      {
        "type": "rich_text",
        "elements": [
          {
            "type": "rich_text_section",
            "elements": [
              {
                "type": "text",
                "text": "Hello, World!"
              }
            ]
          }
        ],
        "blockId": "ylqJ"
      }
    ],
    "ts": "1651568561.160789",
    "is_intro": false,
    "is_starred": false,
    "wibblr": false,
    "displayAsBot": false,
    "upload": false,
    "clientMsgId": "f39ed806-392a-4fb5-a102-cc818aff8164",
    "unfurlLinks": false,
    "unfurlMedia": false,
    "is_thread_broadcast": false,
    "is_locked": false,
    "subscribed": false,
    "hidden": false
  }
}
```

### S3 Source

Creates an event after uploading a file in an S3 bucket. 
The event will have by default empty data. If the file is needed, specify the `ignore_body` parameter to `false`. Be aware there's a 1 MB maximum limitation in the maximum file size supported while using this parameter. 
Depending on the `delete_after_read` attribute, the original file will be deleted or not.

#### S3 Source Configuration Parameters

Every parameter is mandatory if not stated explicitly

* `aws_bucket_name_or_arn` - Bucket name or ARN.
* `aws_region` - The region in which S3 client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example ap-east-1) You’ll need to use the name Region.EU_WEST_1.id().
* `aws_access_key ` - Amazon AWS Access Key.
* `aws_secret_key` - Amazon AWS Secret Key.
* `aws_ignore_body` - If it is true, the S3 Object Body will be ignored completely, if it is set to false the S3 Object will be put in the body. Be aware there's a 1 MB maximum limitation in the maximum file size supported while using this parameter.
* `aws_delete_after_read` - Delete objects from S3 after they have been retrieved.
* `aws_prefix` (optional) - The prefix which is used in the com.amazonaws.services.s3.model.ListObjectsRequest to only consume objects we are interested in.

#### Example of generated event

This is an example of a CloudEvent generated by a _S3 Source_ every time a new file is uploaded in the S3 Bucket.

```json
{
  "specversion": "1.0",
  "id": "3ffb0383-e478-4667-89a3-362c35304749",
  "source": "RHOSE",
  "type": "S3Source",
  "data": "BINARY CONTENT OF THE FILE"
}
```