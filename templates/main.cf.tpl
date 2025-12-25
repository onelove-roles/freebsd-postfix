myhostname = {{ hoster.stdout }}
smtpd_banner = $mydomain ESMTP $mail_name
biff = no
append_dot_mydomain = no
readme_directory = no

smtp_tls_security_level = may
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache
smtpd_tls_security_level = encrypt
smtpd_tls_cert_file = /etc/certs/{{ mail_domain }}/fullchain.pem
smtpd_tls_key_file = /etc/certs/{{ mail_domain }}/privkey.pem
smtpd_sasl_type = cyrus
smtpd_sasl_auth_enable=yes
smtpd_recipient_restrictions =
    permit_mynetworks
    permit_sasl_authenticated
    reject_unauth_destination
    reject_unauth_pipelining
    reject_non_fqdn_helo_hostname
    reject_non_fqdn_sender
    reject_unauth_destination
smtpd_client_restrictions = permit_mynetworks
smtpd_helo_required = yes
smtpd_helo_restrictions = permit_mynetworks, reject_invalid_helo_hostname
smtpd_delay_reject = yes
smtpd_relay_restrictions =
    permit_mynetworks
    permit_sasl_authenticated
    defer_unauth_destination

alias_maps = hash:/etc/mail/aliases
alias_database = hash:/etc/mail/aliases
myorigin = {{ mail_domain }}
mydestination = {{ hoster.stdout }} localhost
relayhost =
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
mailbox_transport = lmtp:inet:cyrus.{{ hoster.stdout }}:2003
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = all

virtual_mailbox_domains = ldap:domains
virtual_alias_maps = ldap:aliases
transport_maps = ldap:transport
virtual_mailbox_maps = ldap:mailboxes
#virtual_transport = lmtp:unix:private/dovecot-lmtp
virtual_transport = lmtp:inet:cyrus.{{ hoster.stdout }}:2003

domains_server_host = ldap.{{ hoster.stdout }}
domains_search_base = dc=account, dc=ldap
domains_query_filter = (&(ou=%s)(objectClass=organizationalUnit))
domains_result_attribute = ou
domains_scope = one
domains_cache = no
domains_bind = yes
domains_bind_dn = cn=postfix,dc=service,dc=ldap
domains_bind_pw = Sekrit
domains_version = 3
domains_start_tls = yes

aliases_server_host = ldap.{{ hoster.stdout }}
aliases_search_base = ou=%d, dc=account, dc=ldap
aliases_query_filter = (&(uid=%u)(objectClass=person)(memberOf=cn=mail,dc=group,dc=ldap)(userClass=active))
aliases_result_attribute = otherMailbox
aliases_scope = one
aliases_cache = no
aliases_bind = yes
aliases_bind_dn = cn=postfix,dc=service,dc=ldap
aliases_bind_pw = Sekrit
aliases_version = 3
aliases_start_tls = yes

transport_server_host = ldap.{{ hoster.stdout }}
transport_search_base = ou=%d, dc=account, dc=ldap
transport_query_filter = (&(uid=%u)(objectClass=person)(memberOf=cn=mail,dc=group,dc=ldap)(userClass=active))
transport_result_attribute = textEncodedORAddress
transport_scope = one
transport_cache = no
transport_bind = yes
transport_bind_dn = cn=postfix,dc=service,dc=ldap
transport_bind_pw = Sekrit
transport_version = 3
transport_start_tls = yes

mailboxes_server_host = ldap.{{ hoster.stdout }}
mailboxes_search_base = ou=%d, dc=account, dc=ldap
mailboxes_query_filter = (&(uid=%u)(objectClass=person)(memberOf=cn=mail,dc=group,dc=ldap)(userClass=active))
mailboxes_result_attribute = mail
mailboxes_scope = one
mailboxes_cache = no
mailboxes_bind = yes
mailboxes_bind_dn = cn=postfix,dc=service,dc=ldap
mailboxes_bind_pw = Sekrit
mailboxes_version = 3
mailboxes_start_tls = yes

milter_default_action = accept
smtpd_milters = inet:rspamd.{{ hoster.stdout }}:11332
non_smtpd_milters = inet:rspamd.{{ hoster.stdout }}:11332
body_checks_size_limit = 26214400
message_size_limit = 26214400
compatibility_level = 3.6
cyrus_sasl_config_path = /usr/local/etc/postfix/sasl
