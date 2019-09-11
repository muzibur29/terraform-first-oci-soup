resource "oci_core_instance" "FoggyKitchenWebserver1" {
  availability_domain = "${var.ADs[0]}"
  compartment_id = "${oci_identity_compartment.FoggyKitchenCompartment.id}"
  display_name = "FoggyKitchenWebServer1"
  shape = "${var.Shapes[0]}"
  subnet_id = "${oci_core_subnet.FoggyKitchenSubnet1.id}"
  source_details {
    source_type = "image"
    source_id   = "${var.Images[0]}"
  }
  metadata = {
      ssh_authorized_keys = "${var.public_key_oci}"
  }
  create_vnic_details {
     subnet_id = "${oci_core_subnet.FoggyKitchenSubnet1.id}"
     assign_public_ip = true 
  }
}

data "oci_core_vnic_attachments" "FoggyKitchenWebserver1_VNIC1_attach" {
  availability_domain = "${var.ADs[0]}"
  compartment_id = "${oci_identity_compartment.FoggyKitchenCompartment.id}"
  instance_id = "${oci_core_instance.FoggyKitchenWebserver1.id}"
}

data "oci_core_vnic" "FoggyKitchenWebserver1_VNIC1" {
  vnic_id = "${data.oci_core_vnic_attachments.FoggyKitchenWebserver1_VNIC1_attach.vnic_attachments.0.vnic_id}"
}

output "FoggyKitchenWebserver1PublicIP" {
value = ["${data.oci_core_vnic.FoggyKitchenWebserver1_VNIC1.public_ip_address}"]
}
