const String googleServiceAccount = "ewogICJ0eXBlIjogInNlcnZpY2VfYWNjb3VudCIsCiAgInByb2plY3RfaWQiOiAiZW1ibGFmbHV0dGVyLTE2MDM5MTYxNzg4MTAiLAogICJwcml2YXRlX2tleV9pZCI6ICIyZGU5ZDgwY2JlYTEzMGFhMGI1NzE1Y2IwMTI1ZGEzYzJkZmJlZGVhIiwKICAicHJpdmF0ZV9rZXkiOiAiLS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tXG5NSUlFdkFJQkFEQU5CZ2txaGtpRzl3MEJBUUVGQUFTQ0JLWXdnZ1NpQWdFQUFvSUJBUUNUelAyRTExdWlBOU5qXG44NHdUZXpjRUptbEJSbXlTWFRBTHIwL2ZtT1Y4aDZES0FNS3FhMnpZNFNTV3pNUm9MSjl1RllQSjBpUXpVaGZpXG4zbDJSMytDSFpkeG1DdnZreG1USUkvdlBJZit2dkoyeEVIN1F4OXU1V2tIU1BIa2p3em5OcjNweGxsblljTjZvXG52a2tIdkpYWEVQTVdXTG5NcHZHeHZxeXJDcGtEVkczbDFveE9BRmpnUnkzc1dsa3hXVG9KbisvcTkwRTFOSVhvXG4yZmFTMEh3OGZPeC83SHJJQ3VVK0h3Q3dqZFdEWGN4aVB4VXlsaVFBTmlXVGRTSzhaUlNUL3dlQVhEM0FsYVMvXG4vRjl0TEZkNDBIa1dlOTg3eUhLZE5Hb3gzU0w4T2E3Sm9zZEttMFBMS3phZ0VQNUptUDZ1dGdmYnBnVHNzVnBtXG5rT1ZoZTVVeEFnTUJBQUVDZ2dFQURpY1ZhWmlEbmo1MmlmNGl2aVRRemxWdFE4SmVHQi9UUDNNd2wwMFpRSFR1XG5TUm1NaW13UjlxeU1aK0pBdG1iN2R6dVpMSVN5VWJXOU1zeXZNZzQ1ZmsyYkxxeERsWk1IeUlCbGx0NS9FTkZqXG5XamFscGhGVk1XajZuNHFKNFFwTEtTNXg3NW1CamUrMDZueWFHcU1NeUJUSDZpNWgwRDUySzFxQ1J6aVRFVlhwXG5rMW9WenNqYmpKa1l1MktIQnlabTIzd3pHSVpiM1p3T3A2bEFDRURMa3hycklsS0tZOGt5Zm41eWIxeFdRT1FsXG44T282Vk9ZdzNSOGovK21OeklYZDFHNnI4TG1ZZHRQWU1PQkluRjJnYzRscmYraXJlTVJPamNxSE5ySmRiQmN0XG5kc0tkSzZSY29Id2lFY3E1N3A5LzJDeDlaT0VBOUh1Unk4dWtGUzNzU1FLQmdRREdtL1YzU3BUU29zby9OaW9RXG51UUowU1cweDlHY0FYTDcwTmQzZ0l2TjNXSUVINTMvRjhUSlpramxpRUJMSzZzQjhyL2Y5aXA1ci9tQUVYa0xXXG5BdmdmY2pTaHlVaU95UlB5M0Z3SFJOQVFWeUFmUU9nalhyQkQyNzhFU2pWRkNjamR1QUZTaS9TbDE3Znd5Q2xYXG5PREE5RHhKZTFCT1hXT1ZwTHBzVkZDODVSUUtCZ1FDK2duNS9lQzlSNGlwcC9aWlB0Q1VxelJEMk1Ccks3dHVxXG5KVit0WDMzbFFsd3lZUC9jU3krQmkvK3dpd2hUUXJVUFhNUjdWSHVTdi9tZGU3UzZmeVV2OGJIbjdyS0wyTUdPXG5jM0h4TllHMm9sWXMzY3BDWWd5NkdqNFB1Q1grN2pHdnVRRGxPUGdTSGUwWnY2UWNGeW4wdXhtaDZwemJpWFJZXG4zREtaM3NuTS9RS0JnSGF3YXkvLy9SSW53TStuMGRtdWhwM3g1M1NzQndYN1p3NVFScWtVbWdUZmVqUzhEdXErXG42b1VHMG80YzV1NG0vaU5Ga2VFTi93Q3d3cmE1a2gyTkpyUzhMbUhsQlJ4M1pCbUZ3T1dESlFndTJQNTBib1g4XG5wei9XU2NBSmpPNFdHOWtNaHBYTEY4Z29NeitNanRBVnZ4WXVOSjlCQS9nMVl0dkp3MW9FZHZnMUFvR0FFYkJDXG5HSW5MTXZvaDRBZDRubHZtbTR2QXlHcjlBZHlkcnJXYnBaaFpNeUV2T0VwRFYydnZ0RUtRY2c3bXJmeGluVk9LXG50cnpJWUg3TXFXK2ovekR3L2Z1ZC9oL3VtZ2Q5S1VIVTBZV2JUcDdTQzRab1VqT1NaUEVzMC83UUlGUnpicEpwXG4zOTZqUWVOZmNXV1cwampnWDJYRDRvSExJS01wbDFxU3BERElZZTBDZ1lBa2s2S0VaYnFZZmluaVBOT1hBVEFNXG5BNlgzSldwN0pVTFpycHZ3T2hMNk1vNXZkWEpNblo0Z0gzaHQrMEg2THo2RDlMQWdZQ3pBVjg3WStoWXllSThEXG5KdXhPVTExVCtVaTlMS0xjakpsa1pzTDBDZVdVQzdwWUlxc29MQkxZd3g1cHUza2NPdHdWNGErMG5GLzMyY2czXG5PRGVDRjNBZGRsL25pZFZrYmg0YmdnPT1cbi0tLS0tRU5EIFBSSVZBVEUgS0VZLS0tLS1cbiIsCiAgImNsaWVudF9lbWFpbCI6ICJzdGFydGluZy1hY2NvdW50LXBhdzNpMzRpZDEwNEBlbWJsYWZsdXR0ZXItMTYwMzkxNjE3ODgxMC5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsCiAgImNsaWVudF9pZCI6ICIxMDkyNjYxMTczNjU0MzQzMDM2MjAiLAogICJhdXRoX3VyaSI6ICJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20vby9vYXV0aDIvYXV0aCIsCiAgInRva2VuX3VyaSI6ICJodHRwczovL29hdXRoMi5nb29nbGVhcGlzLmNvbS90b2tlbiIsCiAgImF1dGhfcHJvdmlkZXJfeDUwOV9jZXJ0X3VybCI6ICJodHRwczovL3d3dy5nb29nbGVhcGlzLmNvbS9vYXV0aDIvdjEvY2VydHMiLAogICJjbGllbnRfeDUwOV9jZXJ0X3VybCI6ICJodHRwczovL3d3dy5nb29nbGVhcGlzLmNvbS9yb2JvdC92MS9tZXRhZGF0YS94NTA5L3N0YXJ0aW5nLWFjY291bnQtcGF3M2kzNGlkMTA0JTQwZW1ibGFmbHV0dGVyLTE2MDM5MTYxNzg4MTAuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iCn0K";

const String queryAPIKey = "VTNabGFXNWlhbTl5Ymt4aGJtZGlaWE4wZFhJSw==";
