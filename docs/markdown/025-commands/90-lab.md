# Labs and database

Download the lab sources here: https://storage.googleapis.com/hm-sfeir-institute-dbt/labs.zip
Download the slides as PDF here: https://storage.googleapis.com/hm-sfeir-institute-dbt/slides.zip

**Settings to connect to the Cloud SQL Database for the labs:**

|               |                                             |
| ------------- | ------------------------------------------- |
| host          | `104.199.105.66`                            |
| port          | `5432`                                      |
| user/password | `dbt/dibiti`                                |
| dbname        | `dbt_XXX(replace XXX with you seat number)` |
| schema        | `dbt`                                       |

##==##

<!-- .slide: class="exercice" -->

# Create your first _dbt_ project

## Lab

- Install _dbt_
- Create your first _dbt_ project
- Configure project and profile
- Create a static first model

Notes:

- profile.yml file is in the $HOME/.dbt folder

No explicit “lab” folder for this part, it depends on the setup of the students.

– Install and configure dbt with each of them.
