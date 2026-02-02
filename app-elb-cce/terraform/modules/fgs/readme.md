Examples:

resource "huaweicloud_fgs_function" "event_function" {
  name         = "fg_basic_py_event"
  runtime      = "Python3.9"
  memory_size  = 128
  timeout      = 30
  handler      = "index.handler"
  app          = "default"
  agency       = huaweicloud_identity_agency.functiongraph_agency.name

  #code_type   = "inline"
  #func_code = <<-EOF
  #  def handler(event, context):
  #      return {
  #          "statusCode": 200,
  #          "body": "Function created. Please upload real code."
  #      }
  #  EOF
  
  # Usar código desde OBS
  code_type = "obs"
  code_url  = "https://${module.obs_app.bucket_name}.obs.${var.region}.myhuaweicloud.com/fg-basic-py-event.zip"

  tags         = var.tags

  depends_on = [huaweicloud_obs_bucket_object.function_zip]
}