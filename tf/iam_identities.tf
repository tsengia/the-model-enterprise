#
# IAM Groups
#
resource "aws_iam_group" "executives" {
    name = "Executives"
    path = var.iam_path_prefix
}

resource "aws_iam_group" "operators" {
    name = "Operators"
    path = var.iam_path_prefix
}

resource "aws_iam_group" "managers" {
    name = "Managers"
    path = var.iam_path_prefix
}

resource "aws_iam_group" "developers" {
    name = "Developers"
    path = var.iam_path_prefix
}

resource "aws_iam_group" "contractors" {
    name = "Contractors"
    path = var.iam_path_prefix
}

#
# IAM Users
#
resource "aws_iam_user" "executive_alice" {
    name = "ExecutiveAlice"
    path = var.iam_path_prefix
}

resource "aws_iam_user" "operator_bob" {
    name = "OperatorBob"
    path = var.iam_path_prefix
}

resource "aws_iam_user" "developer_crystal" {
    name = "DeveloperCrystal"
    path = var.iam_path_prefix
}

resource "aws_iam_user" "manager_ed" {
    name = "ManagerEd"
    path = var.iam_path_prefix
}

resource "aws_iam_user" "contractor_fred" {
    name = "ContractorFred"
    path = var.iam_path_prefix
}

#
# IAM Roles
#
resource "aws_iam_role" "admin_role" {
    name = "AdminRole"
    path = var.iam_path_prefix
    assume_role_policy = aws_iam_policy.assume_admin_role.policy
    max_session_duration = 60*60 // 60 seconds * 60 minutes = 1 hour
}