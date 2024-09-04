const express = require('express');
const oracledb = require('oracledb');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(cors());

// 오라클 DB 연결 설정
// 해당 폴더는 필요하면 가빈이에게 달라고 하기!
// 필요하면 이 경로를 가지고 시스템 환경변수 path에 등록해야 함
// 이 파일이 잘 실행되는지 보려면 cmd에서 node index.js하면 됨!
oracledb.initOracleClient({ libDir: 'C:/SSAFY/DB/instantclient-basic-windows.x64-23.4.0.24.05/instantclient_23_4' }); // Instant Client 경로 설정
const dbConfig = {
  user: 'solstory',
  password: 'eyessolstory',
  connectString: '10.0.2.2:1521/solstory'
};

app.post('/signup', async (req, res) => {
  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);

    const {user_id, password, user_name, email, gender, birth} = req.body;
    const result = await connection.execute(
      `INSERT INTO users (user_id, password, user_name, email, gender, birth)
       VALUES (:user_id, :password, :user_name, :email, :gender, :birth)`,
      [user_id, password, user_name, email, gender, birth],
      { autoCommit: true }
    );

    res.status(200).json({ message: '회원가입 성공', result });
  } catch (err) {
    res.status(500).json({ message: '회원가입 실패', error: err });
  } finally {
    if (connection) {
      try {
        await connection.close();
      } catch (err) {
        console.error(err);
      }
    }
  }
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
