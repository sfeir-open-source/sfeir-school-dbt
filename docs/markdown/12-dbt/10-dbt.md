
# Core concepts
<!-- .slide: class="two-column" -->
![center hm-800](./assets/images/docs/markdown/12-dbt/analytics-engineering-dbt.png)

##--##
<!-- .slide: data-background="var(--black)"-->

# 
<br/>

![sfeir-icons big](edit) Transformation are expressed with SQL `SELECT` statement only

![sfeir-icons big](refresh-ccw) Reference between models are automatically build

![sfeir-icons big](target) Tests ensure model accuracy

![sfeir-icons big](book) Documentation is accessible and easily updated

![sfeir-icons big](edit-3) KISS: use macros to write reusable SQL

##==##

# Open Source but not only

|                 | dbt Core                                                                                                | dbt Cloud                                                                                                                                                                                               |
|-----------------|---------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Advantage       | <span style="font-size:32px">More flexible and customizable</span>                                      | <span style="font-size:32px">Short time to value</span>                                                                                                                                                 |
| Model           | <span style="font-size:32px">Command-line interface (CLI)</span>                                        | <span style="font-size:32px">Web-integrated IDE</span>                                                                                                                                                  |
| Pricing         | <span style="font-size:32px">Free to user</span>                                                        | <ul style="font-size:32px"><li>Developer ⇒ free for one developper seat </li><li>Team ⇒ $100 / dev / month (max 8 seats) </li><li>Custom ⇒ $300 / dev / month (min 5 seats)</li>                        |
| Functionalities | <span style="font-size:32px">Possibility to add features and enhancements while it’s open-source</span> | <span style="font-size:32px">IDE browser-based, job scheduling, job logging, monitoring, alerting, job documentation, version control integration, SSO, role-based access control, access to API</span> |
