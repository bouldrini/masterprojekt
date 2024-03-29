Rahmbedingungen:
	- Hoster 'Digital Ocean'
	- Betriebssystem 'Ubuntu 16.04'
	- gleich große Server



Kernfrage
	- Wieviele Knoten von einer Serverkategorie braucht es mindestens um eine festgelegte Anzahl an Requests pro Sekunde auf ein Cluster mit einer festgelegten Datenmenge innerhalb einer festgelegten Zeitspanne abzuarbeiten ?



Szenarien
	- Serverkategorien:
		- Min: 	  40,00$,  8GB RAM,  160GB SSD
		- Medium: 80,00$,  16GB RAM, 320GB SSD
		- Large:  160,00$, 32GB RAM, 640GB SSD

	- Datenmenge:
		- Beispieldokument (1.37 KB -> 1402 B):
			{
			  "title":varchar(128), 
			  "description":varchar(1000),
			  "price_per_month":int(5),
			  "caution":int(5),
			  "longitude":float(2,8),
			  "latitude":float(2,8),
			  "street":varchar(32),
			  "city":varchar(32),
			  "zip_code":varchar(8),
			  "inserat_type":boolean(1)
			}

		- 8.000.000 Dokumente -> ca. 10.5 GB Datenmenge
		- 16.000.000 Dokumente -> ca. 21.0 GB Datenmenge
		- 32.000.000 Dokumente -> ca. 42.0 GB Datenmenge
		- ...

	- festgelegte Anzahl an Requests pro Sekunde:
		- 4.0  Requests/Sekunde  ->  10.368.000 Requests/Monat 	(> fluege.de)
		- 8.0  Requests/Sekunde  ->  20.736.000 Requests/Monat 	(< trivago.com)
		- 16.0 Requests/Sekunde  ->  41.472.000 Requests/Monat 	(> immoscout24.com)
		- 32.0 Requests/Sekunde  ->  82.944.000 Requests/Monat 	(-)

	- festgelegte Antwortzeiten (Responsetimekategorien)
		- schlecht (6 - 8 Sekunden)
		- mittel (4 - 6 Sekunden)
		- gut (2 - 4 Sekunden)



Umsetzung:
	- Ansible Playbook zum Aufsetzen des Elasticsearch Clusters (Beitrag zur Literatur)
		- Ubuntu 16.04
		- empfohlene Elasticsearch und Systemeinstellungen
			- Referenz: https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html
			- Definitive Guide: https://www.elastic.co/guide/en/elasticsearch/guide/current/index.html
		- dynamisch skalier- und konfigurierbar (Anzahl der Server und Knotenkonfiguration einfach änderbar)
		
		- orientiert sich an
			- https://galaxy.ansible.com/geerlingguy/java
			- https://galaxy.ansible.com/geerlingguy/elasticsearch

			- (https://galaxy.ansible.com/geerlingguy/logstash)
			- (https://galaxy.ansible.com/geerlingguy/kibana)

	- Script zum Indexieren der Beispieldaten in PHP
		- https://www.elastic.co/guide/en/elasticsearch/client/php-api/current/index.html

	- Definition einer geeigneten Query Abfrage
		- Volltextsuche auf title und description
		- Geo-distance Filter mit longitude und latitude
		- Filter nach Preis

	- (Erstellung eines K6 Scripts für das Lasttest Tool app.loadimpact.com
		- Übertragen der Query Abfrage in K6)


Testdurchführung:
	- Tests mit einem Cload Basierten Lasttest Tool 
		- app.loadimpact.com (oder Loader.io)
		- Tests pro Kombination aus Serverkategorie, Serveranzahl, Datenmenge und Requestanzahl
		- Einstufung in Responsetimekategorie


Dokumentation der Ergebnisse
	- Abgabe
		- Ansible Playbooks
		- Script zur Beispieldatengenerierung
		- Beispiel Query Abfrage
		- (K6 Script für Lasttest Tool)

	- Diagramme für Avg. Responsetime je Szenario
	- Tabelle mit Testergebnissen

	- Auswertung
		- Beantwortung der Kernfrage:
			- Wieviele Knoten von einer Serverkategorie braucht es mindestens um eine festgelegte Anzahl an Requests pro Sekunde auf ein Cluster mit einer festgelegten Datenmenge innerhalb einer festgelegten Zeitspanne abzuarbeiten ?

		- Welche Serverkategorie ist für jedes Testszenario mit guten Antowrtzeiten zu wählen, sodass die Kosten für den Betrieb des Clusters minimal werden ?
