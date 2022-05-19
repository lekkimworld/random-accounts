List<Account> accounts = new List<Account>();
for (Integer i=0; i<1000; i++) {
    Account a = new Account(Name='Account-' + i);
    accounts.add(a);
}
INSERT accounts;
