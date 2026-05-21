from flask import Flask, jsonify, request

app = Flask(__name__)


def calculate_churn_risk(data):
    score = 0

    if data.get("months_since_login", 0) > 3:
        score += 30
    if data.get("num_products", 3) < 2:
        score += 25
    if data.get("has_mortgage", True) == False:
        score += 20
    if data.get("num_complaints", 0) > 1:
        score += 15
    if data.get("age_years", 5) < 2:
        score += 10

    if score >= 60:
        risk = "high"
    elif score >= 30:
        risk = "medium"
    else:
        risk = "low"

    return {"risk_score": score, "risk_level": risk}


@app.route("/health")
def health():
    return jsonify({"status": "ok"})


@app.route("/predict", methods=["POST"])
def predict():
    data = request.get_json()
    if not data:
        return jsonify({"error": "No input data"}), 400
    result = calculate_churn_risk(data)
    return jsonify(result)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)