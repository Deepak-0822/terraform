{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/EC2",
            "CPUUtilization",
            "InstanceId",
            "${instance_id}"
          ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "ap-south-1",
        "title": "${instance_id} - CPU Utilization"
      }
    },
    {
      "type": "text",
      "x": 0,
      "y": 7,
      "width": 3,
      "height": 3,
      "properties": {
        "markdown": "My Demo Dashboard"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 14,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/EC2",
            "NetworkIn",
            "InstanceId",
            "${instance_id}"
          ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "ap-south-1",
        "title": "${instance_id} - NetworkIn"
      }
    }
  ]
}
