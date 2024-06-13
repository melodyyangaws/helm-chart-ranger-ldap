# How to start

Spin up a LDAP server and its phpadmin webUI first:
```bash
helm install ldap charts/openldap -f charts/openldap/values.yaml -n YOUR_NAMESPACE --debug
```
```
>> kubectl get all -n kyuubi

NAME                           READY   STATUS      RESTARTS        AGE
pod/ldap-79cb9f6c89-b4lbs      1/1     Running     1 (7h51m ago)   7d20h
pod/ldap-php-7dc58987b-g8srj   1/1     Running     1 (7h51m ago)   7d20h
pod/ldap-test-irdkp            0/1     Completed   0               6d19h

NAME                           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                                  AGE
service/ldap-php-svc           ClusterIP   10.100.155.9     <none>        8080/TCP                                 7d20h
service/ldap-svc               ClusterIP   10.100.250.9     <none>        389/TCP,636/TCP                          7d20h

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/ldap       1/1     1            1           7d20h
deployment.apps/ldap-php   1/1     1            1           7d20h

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/ldap-79cb9f6c89      1         1         1       7d20h
replicaset.apps/ldap-php-7dc58987b   1         1         1       7d20h
```

Double check your ldap service endpoint in the file `charts/ranger/ranger-admin/install.properties`. Make sure the value for `xa_ldap_url` is in the correct format: `ldap://LDAP_SERVICE_NAME.NAMESPACE.svc.cluster.local:LDAP_PORT`. For example: ldap://ldap-svc.kyuubi.svc.cluster.local:389 - i installed the LDAP server in a seperate namespace called "kyuubi".

Finally, install the Ranger component. It includes:
1. Ranger admin server
2. Ranger's user sync service - synchronization info from the LDAP server installed earlier.
3. Postgresql database - Ranger uses the database as its data store (policy, user).
4. ElasticSearch - Ranger uses it to store audit logs.

```bash
helm install ranger charts/ranger -f charts/ranger/values.yaml -n YOUR_NAMESPACE --debug
```

```
>> kubectl get all -n hive

NAME                                     READY   STATUS        RESTARTS       AGE
pod/ranger-admin-5d7797d678-x4xxh        1/1     Running       0              6s
pod/ranger-es-df7495899-rtp8z            1/1     Running       0              6s
pod/ranger-postgresdb-6b9cc79869-fjx52   1/1     Running       0              6s
pod/ranger-usersync-7fb457985c-lbndn     1/1     Running       0              6s

NAME                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/ranger-admin      ClusterIP   10.100.108.7     <none>        6080/TCP   7s
service/ranger-es-svc     ClusterIP   10.100.133.121   <none>        9200/TCP   7s
service/ranger-postgres   ClusterIP   10.100.35.146    <none>        5432/TCP   7s

NAME                                READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/ranger-admin        1/1     1            1           7s
deployment.apps/ranger-es           1/1     1            1           7s
deployment.apps/ranger-postgresdb   1/1     1            1           7s
deployment.apps/ranger-usersync     1/1     1            1           7s

NAME                                           DESIRED   CURRENT   READY   AGE
replicaset.apps/ranger-admin-5d7797d678        1         1         1       7s
replicaset.apps/ranger-es-df7495899            1         1         1       7s
replicaset.apps/ranger-postgresdb-6b9cc79869   1         1         1       7s
replicaset.apps/ranger-usersync-7fb457985c     1         1         1       7s
```