# Projet DevOps IIM

## 👥 Membres de l'équipe et rôles

- **Ketchuskana SON ESSOME MOUKOURI** : Pipeline CD pour le backend  
- **Myriam BENABDESSADOK** : Pipeline CD pour le frontend  
- **Salma WADOUACHI** : Pipeline CI pour le frontend  
- **Axelle NIGON** : Pipeline CI pour le backend  

---

## 📋 Prérequis

- Compte **AWS** avec droits suffisants pour créer des ressources (IAM, API Gateway, DynamoDB, etc.)  
- **NodeJS** version 20  
- **NPM** (gestionnaire de paquets Node.js)  

---

## ⚙️ Configuration AWS

Avant d’activer la pipeline de déploiement (`cd.yml`), un rôle **IAM** doit être créé pour autoriser GitHub Actions à déployer les ressources Terraform.

1. Connectez-vous à la console AWS  
2. Allez dans **IAM > Rôles > Créer un rôle**  
3. Sélectionnez **Services d’approbation personnalisée** (Custom trust policy)  
4. Copiez-collez le JSON suivant en remplaçant les `{}` par vos valeurs :

````markdown
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::{ID_DE_VOTRE_COMPTE_AWS}:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
          "token.actions.githubusercontent.com:sub": "repo:{VOTRE_ID_GITHUB}/{NOM_DU_REPO}:ref:refs/heads/{BRANCHE_PRINCIPALE}"
        }
      }
    }
  ]
}
````

5. Dans **Autorisations**, attachez :

   * `AmazonS3FullAccess`
   * `CloudFrontFullAccess`
   * `IAMFullAccess`

6. Créez le rôle et copiez son **ARN**.

---

## 🔑 Configuration GitHub

1. Dans votre dépôt GitHub : **Settings > Secrets and variables > Actions > New repository secret**
2. Créez un secret :

   * **Nom** : `AWS_IAM_ROLE`
   * **Valeur** : ARN du rôle AWS créé précédemment

---

## 🔄 Fonctionnement des pipelines CI/CD

* **Pipeline CI**

  * Déclenchée sur push dans une branche autre que la principale
  * Tests, lint, build

* **Pipeline CD**

  * Déclenchée sur Pull Request vers la branche principale
  * Provisionne les ressources AWS via Terraform et déploie les applications Frontend & Backend

---

## ☁️ Architecture Cloud

* **Architecture cible**

  * Service de conteneurs managé (AWS ECS/Fargate) pour Backend & Frontend
* **Ressources nécessaires**

  * DynamoDB (Base de données)

---

## 📦 Provisioning avec Terraform

1. Configurer le provider AWS
2. Définir les ressources : VPC, ECS, DynamoDB, API Gateway, IAM
3. Tester avec `terraform plan`
4. Appliquer avec `terraform apply`

---

## ⚙️ Pipeline CI/CD

Étapes principales :

* Cloner le dépôt
* Déploiement via `terraform apply`

---

## ⚠️ Problème rencontré

Un problème persiste lors du déploiement avec la pipeline CD via GitHub Actions.

* Les droits AWS semblent corrects (captures jointes)
* Déploiement **réussi en local** via mes clés AWS personnelles (URL fonctionnelle)
* Problème probablement lié aux credentials ou à la configuration IAM pour GitHub Actions

---

💡 **Étape suivante** : Investiguer la configuration IAM (Trust Policy & permissions) afin que GitHub Actions puisse assumer correctement le rôle AWS.
