# Projet DevOps IIM

Rôles de chaque membre de l'équipe :

  - Ketchuskana SON ESSOME MOUKOURI : CD pipeline pour le back
  - Myriam BENABDESSADOK : CD pipeline pour le front
  - Salma WADOUACHI : CI pipeline pour le front
  - Axelle NIGON : CI pipeline pour le back

# Requis

  - Un compte AWS
  - NodeJS version 20
  - NPM package manager

# Configuration AWS

Tout d'abord, avant d'entamer l'activation de la pipeline de déploiement (cd.yml), il faut créer une secret key pour autoriser AWS a créer des ressources Terraform depuis Github.
Cela se passe au niveau du module "IAM" de la console AWS. Il faut se rendre dans IAM>Rôles>Créer un rôle. Lorsque vous avez donner un nom à votre rôle et sélectionné l'option "Services d'approbation personnalisée", copier-coller le JSON si dessous comme suit :

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::{id de votre compte AWS}:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
                    "token.actions.githubusercontent.com:sub": "repo:{ton identifiant github}/{nom du repo git du projet}:ref:refs/heads/{branche principal du repo git}"
                }
            }
        }
    ]
}

Ensuite, une fois arrivé aux autorisations, vous devez ajoutez les autorisations suivantes : AmazonS3FullAccess, CloudFrontFullAccess et IAMFullAccess. Quand vous cliquer sur le bouton "Créez", il vous suffit de cliquer sur l'arn du rôle.

# Configuration GitHub

Suite à la création du rôle AWS, l'arn du rôle fera office de secret key pour permettre la configuration du compte AWS depuis la pipeline CD pour permettre la création de ressources AWS pour le déploiement du front et du back. Pour cela, vous devez vous rendre dans Settings>Secrets and variables>Create a new secret repository. Enfin, vous mettez comme nom de secret key "AWS_IAM_ROLE" et dans le champ "Secret" l'arn du rôle AWS crée précédemment.

# Fonctionnement du projet

Pour tester les pipeline CI/CD, il suffit simplement de modifier l'un des codes du projet "client" ou "server" sur une autre branche que la branche principal. Puis une fois que les modifications sont délivré via les commandes git add . > git commit -m "{message que vous souhaitez}" > git push origin {la branche que vous avez crée}, la pipline CI s'activera. Une fois que cette pipeline est terminé avec succès, vous pouvez créez un pull request qui activera la pipeline CD pour vérifier si le déploiement se réalise correctement.
Pour tester le site web au complet avec front et API déployé, vous créez un fichier .env à la racine du projet front dans le dossier "client" où vous devez ajouté cet variable d'environnement : TABLE_NAME = {arn de la table DynamoDB déployé}
