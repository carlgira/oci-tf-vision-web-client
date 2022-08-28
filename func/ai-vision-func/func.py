import io
import json
import logging
import oci
import base64

import os
import random

from oci.ai_vision import AIServiceVisionClient
from oci.ai_vision.models import AnalyzeImageDetails, ImageClassificationFeature, InlineImageDetails


from fdk import response

signer = oci.auth.signers.get_resource_principals_signer()
ai_service_vision_client = AIServiceVisionClient({}, signer=signer)


def handler(ctx, data: io.BytesIO = None):
    try:
        body = json.loads(data.getvalue())
        image_base64 = body.get("image")
        model_id = body.get("model_id")

        r = analize_image(image_base64, model_id)

        return response.Response(ctx, response_data=json.dumps(r), headers={"Content-Type": "application/json"})

    except (Exception, ValueError) as ex:
        logging.getLogger().info('error parsing json payload: ' + str(ex))

    logging.getLogger().info("Inside Python Hello World function")
    
    return response.Response(
        ctx, response_data=json.dumps({'problem' : 502}),
        headers={"Content-Type": "application/json"}
    )


def analize_image(image_encoded, model_id=None):

	image_details = InlineImageDetails()
	image_details.data = image_encoded

	image_text_detection_feature = ImageClassificationFeature()
	if model_id is not None:
		image_text_detection_feature.model_id = model_id

	features = [image_text_detection_feature]

	analyze_image_details = AnalyzeImageDetails()
	analyze_image_details.image = image_details
	analyze_image_details.features = features

	res = ai_service_vision_client.analyze_image(analyze_image_details=analyze_image_details)
    
	return oci.util.to_dict(res.data)
