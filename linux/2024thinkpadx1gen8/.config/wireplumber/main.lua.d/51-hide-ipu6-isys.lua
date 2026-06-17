-- hide internal ipu6 isys capture nodes from applications.
-- only the v4l2loopback "Intel MIPI Camera" (/dev/video0) should be visible.
-- Along with external webcams of course.
table.insert(v4l2_monitor.rules, 
  {
    matches = {
      {
        { "device.name", "matches", "v4l2_device.pci-0000_00_05.0*" },
      },
    },
    apply_properties = {
      ["device.disabled"] = true,
    },
  })

table.insert(v4l2_monitor.rules, 
  {
    matches = {
      {
        { "node.name", "matches", "v4l2_input.pci-0000_00_05.0*" },
      },
    },
    apply_properties = {
      ["node.disabled"] = true,
    },
  })
