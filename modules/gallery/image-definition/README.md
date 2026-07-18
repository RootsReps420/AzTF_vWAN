# modules/gallery/image-definition

Deploys a **single Gallery Image Definition** (metadata only). One definition per
OS/SKU combination — instantiate this module twice from the environment for the
**PERS** and **MSH base** definitions.

Packer publishes image **versions** to these definitions; Terraform does not
manage versions. MSH per-business-unit variation is handled by Packer artefacts
at version-build time, so no per-BU definitions are needed.

## Azure resources

- `azurerm_shared_image`

## Security type

`security_type` maps to the provider flags. `TrustedLaunch` (default) and
`ConfidentialVM` require `hyper_v_generation = "V2"`.

## Depends on

- `gallery_name` — output `gallery_name` from `modules/gallery/gallery`

## Outputs

`image_definition_id`, `image_definition_name` (used in Packer `.pkr.hcl` var
files).

See [`examples/basic`](examples/basic) for the PERS + MSH base pattern.
