using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using AutoFormsExample.Properties;
using CLIPSNET;


namespace ClipsFormsExample
{
    public partial class ClipsFormsExample : Form
    {
        private CLIPSNET.Environment clips = new CLIPSNET.Environment();

        public ClipsFormsExample()
        {
            InitializeComponent();
            var facts = new AutoCompleteStringCollection();
            facts.AddRange(Resources.facts.Split('\n'));
            FactBox.AutoCompleteCustomSource = facts;
            FactBox.AutoCompleteMode = AutoCompleteMode.SuggestAppend;
            FactBox.AutoCompleteSource = AutoCompleteSource.CustomSource;

            codeBox.Text = Resources.persons;
            resetBtn_Click(null, null);
        }

        private void HandleResponse()
        {
            //  Вытаскиаваем факт из ЭС
            String evalStr = "(find-fact ((?f ioproxy)) TRUE)";
            FactAddressValue fv = (FactAddressValue) ((MultifieldValue) clips.Eval(evalStr))[0];

            MultifieldValue damf = (MultifieldValue) fv["messages"];
            MultifieldValue vamf = (MultifieldValue) fv["answers"];

            for (int i = 0; i < damf.Count; i++)
            {
                LexemeValue da = (LexemeValue) damf[i];
                byte[] bytes = Encoding.Default.GetBytes(da.Value);
                string message = Encoding.UTF8.GetString(bytes);
                outputBox.Text += message + System.Environment.NewLine;
            }


            if (vamf.Count == 0)
                clips.Eval("(assert (clearmessage))");
        }

        private void nextBtn_Click(object sender, EventArgs e)
        {
            clips.Run();
            HandleResponse();
        }

        private void resetBtn_Click(object sender, EventArgs e)
        {
            outputBox.Text = "Перезагрузка..." + System.Environment.NewLine;
            clips.Clear();
            clips.LoadFromString(codeBox.Text);
            clips.Reset();
            outputBox.Text = "Перезагрузка завершена." + System.Environment.NewLine;
            nextBtn_Click(sender, e);
        }

        private void openFile_Click(object sender, EventArgs e)
        {
            if (clipsOpenFileDialog.ShowDialog() == DialogResult.OK)
            {
                codeBox.Text = System.IO.File.ReadAllText(clipsOpenFileDialog.FileName);
                resetBtn_Click(sender, e);
            }
        }

        private void fontSelect_Click(object sender, EventArgs e)
        {
            if (fontDialog1.ShowDialog() == DialogResult.OK)
            {
                codeBox.Font = fontDialog1.Font;
                outputBox.Font = fontDialog1.Font;
            }
        }

        private void saveAsButton_Click(object sender, EventArgs e)
        {
            clipsSaveFileDialog.FileName = clipsOpenFileDialog.FileName;
            if (clipsSaveFileDialog.ShowDialog() == DialogResult.OK)
            {
                System.IO.File.WriteAllText(clipsSaveFileDialog.FileName, codeBox.Text);
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                float.Parse(massInput.Text, CultureInfo.InvariantCulture);
                clips.Eval($"(assert (element (formula {FactBox.Text}) (mass {massInput.Text})))");
                nextBtn_Click(sender, e);
            }
            catch (Exception exc)
            {
                MessageBox.Show($"{exc.Message}", "Что-то пошло не так", MessageBoxButtons.OK,
                    MessageBoxIcon.Information);
            }
        }

        private void FactBox_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                button1_Click(sender, e);
            }
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }
    }
}