class OtpDetail {
  String key;
  String scheme;
  String otype;
  String account;
  String issuer;
  String secret;
  String algorithm;
  int digits;
  int period;
  int counter;
  String raw;
  String ctime;
  String utime;

  OtpDetail(
      {this.key,
        this.scheme,
        this.otype,
        this.account,
        this.issuer,
        this.secret,
        this.algorithm,
        this.digits,
        this.period,
        this.counter,
        this.raw,
        this.ctime,
        this.utime});

  OtpDetail.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    scheme = json['scheme'];
    otype = json['otype'];
    account = json['account'];
    issuer = json['issuer'];
    secret = json['secret'];
    algorithm = json['algorithm'];
    digits = json['digits'];
    period = json['period'];
    counter = json['counter'];
    raw = json['raw'];
    ctime = json['ctime'];
    utime = json['utime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['scheme'] = this.scheme;
    data['otype'] = this.otype;
    data['account'] = this.account;
    data['issuer'] = this.issuer;
    data['secret'] = this.secret;
    data['algorithm'] = this.algorithm;
    data['digits'] = this.digits;
    data['period'] = this.period;
    data['counter'] = this.counter;
    data['raw'] = this.raw;
    data['ctime'] = this.ctime;
    data['utime'] = this.utime;
    return data;
  }
}

