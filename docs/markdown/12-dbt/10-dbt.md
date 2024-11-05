# Core concepts

<!-- .slide: class="two-column" -->

![center hm-800](./assets/images/docs/markdown/12-dbt/analytics-engineering-dbt.png)

##--##

<!-- .slide: data-background="var(--black)"-->

#

<br/>

![sfeir-icons big](edit) <span style="vertical-align:top">Transformation are expressed with SQL `SELECT` statement only</span>

![sfeir-icons big](refresh-ccw) <span style="vertical-align:top">Reference between models are automatically build</span>

![sfeir-icons big](target) <span style="vertical-align:top">Tests ensure model accuracy</span>

![sfeir-icons big](book) <span style="vertical-align:top">Documentation is accessible and easily updated</span>

![sfeir-icons big](database) <span style="vertical-align:top">KISS: use macros to write reusable SQL</span>

##==##

# Open Source but not only

|                     | dbt Core                                                            | dbt Cloud                                                                                                                                                           |
| ------------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Advantage**       | More flexible and customizable                                      | Short time to value                                                                                                                                                 |
| **Model**           | Command-line interface (CLI)                                        | Web-integrated IDE                                                                                                                                                  |
| **Pricing**         | Free to user                                                        | <ul><li>Developer ⇒ free for one developper seat </li><li>Team ⇒ $100 / dev / month (max 8 seats) </li><li>Custom ⇒ $300 / dev / month (min 5 seats)</li>           |
| **Functionalities** | Possibility to add features and enhancements while it’s open-source | IDE browser-based, job scheduling, job logging, monitoring, alerting, job documentation, version control integration, SSO, role-based access control, access to API |
