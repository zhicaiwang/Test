
import {
  Row,
  Col,
  Card,
  Divider,
  Form,
  Input,
  Button,
  Table,
} from 'antd';
import styles from './index.css';

const HomePage = ({
  form,
}) => {

  const { getFieldDecorator } = form;

  const columns = [
    {
      title: '时间',
      dataIndex: 'date',
    },
    {
      title: '竞猜涨跌',
      dataIndex: 'type',
    },
    {
      title: '竞猜金额',
      dataIndex: 'money',
    },
    {
      title: '竞猜结果',
      dataIndex: 'result'
    }
  ];

  return (
    <div className="pageContent">
      <Card className={styles.card}>
        <Row className={styles.titleInfos} gutter={16}>
          <Col
            className={styles.titleCols}
            xs={24}
            sm={24}
            md={8}
            lg={{span: 6, offset: 3 }}
            xl={{span: 6, offset: 3 }}
            xxl={{span: 4, offset: 6 }}
          >
            <strong>BTC/USDT</strong>
            <span>3738.12</span>
          </Col>
          <Col
            className={styles.titleCols}
            xs={24}
            sm={24}
            md={8}
            lg={6}
            xl={6}
            xxl={4}
          >
            <div>
              <p>
                <strong>今日 BTC 价格</strong>
              </p>
              <p className={styles.colorUp}>3749.26</p>
            </div>
            <div>
              <p>
                <strong>昨日 BTC 价格</strong>
              </p>
              <p className={styles.colorUp}>4183.24</p>
            </div>
          </Col>
          <Col
            className={styles.titleCols}
            xs={24}
            sm={24}
            md={8}
            lg={6}
            xl={6}
            xxl={4}
          >
            <strong>涨跌幅</strong>
            <span className={true ? styles.up : styles.down}>0.34</span>
          </Col>
        </Row>
      </Card>
      <Card className={styles.card}>
        <div className={styles.todayStatus}>
          <h2>
            今日竞猜情况
            <span>
              竞猜开放时间：每日的12:00 - 24:00
            </span>
          </h2>
          <Divider />
          <Row>
            <Col
              xs={24}
              sm={24}
              md={{ span: 10, offset: 2 }}
              lg={{ span: 10, offset : 2 }}
              xl={{ span: 8, offset: 4 }}
              xxl={{ span: 6, offset: 6 }}
            >
              <Row>
                <Col span={12}>
                  当前 RTX 奖池总量
                </Col>
                <Col span={12}>
                  <h2>
                    2612 RTX
                  </h2>
                </Col>
              </Row>
              <Row>
                <Col span={12}>
                  看涨人数
                </Col>
                <Col span={12} className={styles.upRate}>
                  4
                </Col>
              </Row>
              <Row>
                <Col span={12}>
                  看跌人数
                </Col>
                <Col span={12} className={styles.downRate}>
                  6
                </Col>
              </Row>
              <br/>
              <Row>
                <Col span={12}>
                  看涨预期收益率
                </Col>
                <Col span={12} className={styles.upRate}>
                  4%
                </Col>
              </Row>
              <Row>
                <Col span={12}>
                  看跌预期收益率
                </Col>
                <Col span={12} className={styles.downRate}>
                  6%
                </Col>
              </Row>
              <br/>
              <Row>
                <Col span={12}>
                  看涨竞猜金额
                </Col>
                <Col span={12} className={styles.upRate}>
                  400 RTX
                </Col>
              </Row>
              <Row>
                <Col span={12}>
                  看跌竞猜金额
                </Col>
                <Col span={12} className={styles.downRate}>
                  600 RTX
                </Col>
              </Row>
            </Col>
            <Col
              xs={24}
              sm={24}
              md={10}
              lg={10}
              xl={8}
              xxl={6}
            >
              <Row style={{ height: 210 }} type="flex" justify="center" align="bottom">
                <Col span={8} className={styles.todayStatusUp}>
                  <p>38.8%</p>
                  <div
                    className={styles.todayStatusUpMap}
                    style={{ height: 150 * .388 }}
                  />
                  <div>看涨</div>
                </Col>
                <Col span={8} style={{ height: 105 }}>
                  <span className={styles.pk}>pk</span>
                </Col>
                <Col span={8} className={styles.todayStatusDown}>
                  <p>61.2%</p>
                  <div
                    className={styles.todayStatusDownMap}
                    style={{ height: 150 * .612 }}
                  />
                  <div>看跌</div>
                </Col>
              </Row>
            </Col>
          </Row>
        </div>
      </Card>
      <Card className={styles.card}>
        <div className={styles.bet}>
          <h2>
            竞猜下注
          </h2>
          <Divider />
          <Row>
            <Col span={12}>
              <Form layout="inline">
                <Form.Item label="下注数量">
                  {
                    getFieldDecorator('numbers', {

                    })(
                      <Input type="number" />
                    )
                  }
                </Form.Item>
                <Form.Item>
                  <Button
                    style={{
                      background: 'green',
                      color: '#fff',
                    }}
                  >
                    看涨
                  </Button>
                </Form.Item>
              </Form>
            </Col>
            <Col span={12}>
              <Form layout="inline">
                <Form.Item label="下注数量">
                  {
                    getFieldDecorator('numbers', {

                    })(
                      <Input type="number" />
                    )
                  }
                </Form.Item>
                <Form.Item>
                  <Button
                    style={{
                      background: 'red',
                      color: '#fff',
                    }}
                  >
                    看跌
                  </Button>
                </Form.Item>
              </Form>
            </Col>
          </Row>
        </div>
      </Card>
      <Card className={styles.card}>
        <div className={styles.history}>
          <h2>我的竞猜</h2>
          <Divider />
          <Table
            columns={columns}
            locale={{
              emptyText: '暂无数据'
            }}
          />
        </div>
      </Card>
      <Card className={styles.card}>
        <div className={styles.rules}>
          <h2>投注规则</h2>
          <Divider />
          <ol>
            <li>
              投注：平台默认单次最低投注数量100ET,单次最高投注数量10000ET
            </li>
            <li>
              输赢规则：若中奖，返还投注本金，并按赢方本金占比去分取输方的所有投注ET； 若未中奖，失去所有投注本金；平台不收取任何费用
            </li>
            <li>
              如何计算：每局以每天中午12点BTC价格对比第二天中午12点BTC价格计算涨／跌。
            </li>
            <li>
              竞猜开放时间：用户可在每天中午12点至晚上24点进行投注，竞猜当天中午12点至第二天中午12点的BTC价格涨跌。
            </li>
            <li>
              平台奖励发放：每日的18:00前发放上一日投注结果的奖励
            </li>
            <li>
              用于投注的ET，将从充提账户ET余额中的扣除，如ET资产存放在币币账户中，需将ET划转至充提账户。
            </li>
          </ol>
        </div>
      </Card>
      <Card className={styles.card}>
        <div className={styles.note}>
          <h2>获取 RTX 方法</h2>
          <Divider />
          <h3>通过 “交易即挖矿” 获得ET</h3>
          <ol>
            <li>
              只要产生交易，即可按交易额占比100% 返还ET的方式获取
            </li>
            <li>
              通过“合作伙伴”模式，邀请好友注册并交易的方式获取
            </li>
          </ol>
          <h3>交易购买ET</h3>
          <ol>
            <li>
              通过币币交易的形式，购买并持有ET
            </li>
          </ol>
        </div>
      </Card>
    </div>
  );
}

export default Form.create()(HomePage);
