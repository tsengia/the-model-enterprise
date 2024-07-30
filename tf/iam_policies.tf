data "aws_iam_policy_document" "assume_admin_role" {

}

resource "aws_iam_policy" "assume_admin_role" {
    name = "AssumeAdminRole"
    description = "Trust policy that dictates who may assume the Admin Role."
    policy = data.aws_iam_policy_document.assume_admin_role.json
}


data "aws_iam_policy_document" "iam_self_manage" {
    statement {
        sid = "IAMSelfManageCredentials"

        effect = "Allow"

        actions = [
            "iam:ListAccessKeys",
            "iam:GetAccessKeyLastUsed",
            "iam:CreateAccessKey",
            "iam:DeleteAccessKey",
            "iam:UpdateAccessKey",
            "iam:DeleteSSHPublicKey",
            "iam:GetSSHPublicKey",
            "iam:ListSSHPublicKeys",
            "iam:UpdateSSHPublicKey",
            "iam:UploadSSHPublicKey",
            "iam:CreateServiceSpecificCredential",
            "iam:ListServiceSpecificCredentials",
            "iam:UpdateServiceSpecificCredential",
            "iam:DeleteServiceSpecificCredential",
            "iam:ResetServiceSpecificCredential"
        ]

        resources = [
            "arn:aws:iam:*:user/&{aws:username}"
        ]
    }

    statement {
        sid = "IAMSelfManagePassword"

        effect = "Allow"

        actions = [
            "iam:ChangePassword"
        ]

        resources = [
            "arn:aws:iam:*:user/&{aws:username}"
        ]
    }

    statement {
        sid = "IAMViewPassswordPolicy"

        effect = "Allow"

        actions = [
            "iam:GetAccountPasswordPolicy"
        ]

        resources = ["*"]
    }
}

resource "aws_iam_policy" "iam_self_manage" {
    name = "iam_self_manage"
    path = "/"
    description = "Allow a user to manage their own access keys, credentials, password, and certificates."
    policy = data.aws_iam_policy_document.iam_self_manage.json
}